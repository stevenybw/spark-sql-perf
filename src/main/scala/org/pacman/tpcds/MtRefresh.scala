package org.pacman.tpcds

import io.delta.tables.DeltaTable
import org.apache.spark.sql.SparkSession

import java.io.FileInputStream

object MtRefresh {
  val sqlFiles: Array[String] = Array("LF_CR.sql", "LF_CS.sql", "LF_I.sql", "LF_SR.sql", "LF_SS.sql", "LF_WR.sql", "LF_WS.sql")

  def executeSql(spark: SparkSession, db: String, path: String, round: Int): Unit = {
    println(s"Execute: ${path}")
    val fin = new FileInputStream(path)
    val sqlInput = new String(fin.readAllBytes(), "UTF-8").replace("${ROUND}", round.toString)
    val statements = sqlInput.split(";").map(_.strip()).filter(_.nonEmpty).toArray
    fin.close()
    statements.foreach(s => {
      println(s">> ${s}")
      spark.sql(s)
    })
    println(s"Done: ${path}")
  }

  def executeDF_CS(spark: SparkSession, fromDate: String, toDate: String): Unit = {
    val dateRange = spark.sql(s"select min(d_date_sk), max(d_date_sk) from date_dim  where d_date between '${fromDate}' and '${toDate}'").collect().head
    val dateSKMin = dateRange.getInt(0)
    val dateSKMax = dateRange.getInt(1)
    val orderNumberRange = spark.sql(s"select cs_order_number from catalog_sales  where cs_sold_date_sk >= ${dateSKMin} and cs_sold_date_sk <= ${dateSKMax}")
    DeltaTable
      .forName("catalog_returns")
      .merge(orderNumberRange.as("order_to_delete"), "catalog_returns.cr_order_number == order_to_delete.cs_order_number")
      .whenMatched()
      .delete()
      .execute()
    spark.sql(s"delete from catalog_sales where cs_sold_date_sk >= ${dateSKMin} and cs_sold_date_sk <= ${dateSKMax}")
  }

  def executeDF_SS(spark: SparkSession, fromDate: String, toDate: String): Unit = {
    val dateRange = spark.sql(s"select min(d_date_sk), max(d_date_sk) from date_dim where d_date between '${fromDate}' and '${toDate}'").collect().head
    val dateSKMin = dateRange.getInt(0)
    val dateSKMax = dateRange.getInt(1)
    val orderNumberRange = spark.sql(s"select ss_ticket_number from store_sales where ss_sold_date_sk >= ${dateSKMin} and ss_sold_date_sk <= ${dateSKMax}")
    DeltaTable
      .forName("store_returns")
      .merge(orderNumberRange.as("order_to_delete"), "store_returns.sr_ticket_number == order_to_delete.ss_ticket_number")
      .whenMatched()
      .delete()
      .execute()
    spark.sql(s"delete from store_sales where ss_sold_date_sk >= ${dateSKMin} and ss_sold_date_sk <= ${dateSKMax}")
  }

  def executeDF_WS(spark: SparkSession, fromDate: String, toDate: String): Unit = {
    val dateRange = spark.sql(s"select min(d_date_sk), max(d_date_sk) from date_dim  where d_date between '${fromDate}' and '${toDate}'").collect().head
    val dateSKMin = dateRange.getInt(0)
    val dateSKMax = dateRange.getInt(1)
    val orderNumberRange = spark.sql(s"select ws_order_number from web_sales  where ws_sold_date_sk >= ${dateSKMin} and ws_sold_date_sk <= ${dateSKMax}")
    DeltaTable
      .forName("web_returns")
      .merge(orderNumberRange.as("order_to_delete"), "web_returns.wr_order_number == order_to_delete.ws_order_number")
      .whenMatched()
      .delete()
      .execute()
    spark.sql(s"delete from web_sales where ws_sold_date_sk >= ${dateSKMin} and ws_sold_date_sk <= ${dateSKMax}")
  }

  def executeDF_I(spark: SparkSession, fromDate: String, toDate: String): Unit = {
    val dateRange = spark.sql(s"select min(d_date_sk), max(d_date_sk) from date_dim  where d_date between '${fromDate}' and '${toDate}'").collect().head
    val dateSKMin = dateRange.getInt(0)
    val dateSKMax = dateRange.getInt(1)
    spark.sql(s"delete from inventory where inv_date_sk >= ${dateSKMin} and inv_date_sk <= ${dateSKMax}")
  }

  def parseDate(d: String): (String, String) = {
    val sp = d.split(",")
    require(sp.length == 2)
    (sp(0), sp(1))
  }

  def main(args: Array[String]): Unit = {
    val it = args.iterator
    val db = it.next()
    val mtSqlsDir = it.next()
    val round = it.next().toInt
    val date = it.next().split(":")
    val inventory_date = it.next().split(":")
    require(date.size == 3)
    require(inventory_date.size == 3)

    val threadPool = java.util.concurrent.Executors.newFixedThreadPool(4)

    val spark = Utility.createSparkSession(getClass.getName)
    spark.sql(s"use ${db}")
    val f_WS = threadPool.submit(new Runnable {
      override def run(): Unit = {
        date.foreach(d => {
          val (from, to) = parseDate(d)
          executeDF_WS(spark, from, to)
        })
      }
    })
    val f_CS = threadPool.submit(new Runnable {
      override def run(): Unit = {
        date.foreach(d => {
          val (from, to) = parseDate(d)
          executeDF_CS(spark, from, to)
        })
      }
    })
    val f_SS = threadPool.submit(new Runnable {
      override def run(): Unit = {
        date.foreach(d => {
          val (from, to) = parseDate(d)
          executeDF_SS(spark, from, to)
        })
      }
    })
    val f_I = threadPool.submit(new Runnable {
      override def run(): Unit = {
        inventory_date.foreach(d => {
          val (from, to) = parseDate(d)
          executeDF_I(spark, from, to)
        })
      }
    })
    f_WS.get()
    f_CS.get()
    f_SS.get()
    f_I.get()

    val futures_3 = sqlFiles.map(sqlFile => threadPool.submit(new Runnable {
      override def run(): Unit = {
        executeSql(spark, db, s"${mtSqlsDir}/${sqlFile}", round)
      }
    })).toArray
    futures_3.foreach(_.get())

    threadPool.shutdown()
  }
}
