package com.databricks.spark.sql.perf.tpcds

import org.apache.hadoop.fs.Path
import org.apache.spark.sql.{SaveMode, SparkSession}
import org.apache.spark.util.SerializableConfiguration

object LoadData {
  def main(args: Array[String]): Unit = {
    val it = args.iterator
    val srcLocation = it.next()
    val dsdgenDir = it.next()
    val scaleFactor = it.next()
    val numPartitions = it.next().toInt
    val DB = it.next()
    val dstLocation = it.next()

    val spark = SparkSession
      .builder()
      .appName(getClass.getName)
      .getOrCreate()

    spark.sql(s"drop database if exists $DB cascade")
    spark.sql(s"create database $DB")
    spark.sql(s"use $DB")

    val tables = new TPCDSTables(spark.sqlContext,
      dsdgenDir = dsdgenDir,
      scaleFactor = scaleFactor)

    tables.tables.foreach(table => {
      println(s"Loading table ${table.name}")
      val tableLocation = s"${dstLocation}/${table.name}"
      println(s"[CREATE TABLE] ${table.name}")
      spark.catalog.createTable(table.name, tableLocation, "parquet")
      println(s"[RECOVER PARTITIONS] ${table.name}")
      if (table.partitionColumns.nonEmpty) {
        spark.sqlContext.sql(s"ALTER TABLE ${table.name} RECOVER PARTITIONS")
      }
      println(s"[COMPUTE STATISTICS] ${table.name}")
      spark.sqlContext.sql(s"ANALYZE TABLE ${table.name} COMPUTE STATISTICS")
      val allColumns = table.fields.map(_.name).mkString(", ")
      println(s"[COMPUTE STATISTICS FOR COLUMNS] ${table.name}")
      spark.sqlContext.sql(s"ANALYZE TABLE ${table.name} COMPUTE STATISTICS FOR COLUMNS $allColumns")
    })
  }
}
