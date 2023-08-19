package org.pacman.tpcds

import org.apache.spark.sql.SparkSession

import java.io.FileInputStream

object MtRefresh {
  val sqlFiles: Array[String] = Array("DF_CS.sql", "DF_I.sql", "DF_SS.sql", "DF_WS.sql", "LF_CR.sql", "LF_CS.sql", "LF_I.sql", "LF_SR.sql", "LF_SS.sql", "LF_WR.sql", "LF_WS.sql")

  def executeSql(inputSpark: SparkSession, db: String, path: String, round: Int): Unit = {
    val spark = inputSpark.newSession()
    spark.sql(s"use ${db}")
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

  val threadPool = java.util.concurrent.Executors.newFixedThreadPool(16)

  def main(args: Array[String]): Unit = {
    val it = args.iterator
    val db = it.next()
    val mtSqlsDir = it.next()
    val round = it.next().toInt

    val spark = Utility.createSparkSession(getClass.getName)

    val futures = sqlFiles.map(sqlFile => threadPool.submit(new Runnable {
      override def run(): Unit = {
        executeSql(spark, db, s"${mtSqlsDir}/${sqlFile}", round)
      }
    })).toArray
    futures.foreach(_.get())
  }
}
