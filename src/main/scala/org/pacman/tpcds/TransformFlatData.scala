package org.pacman.tpcds

import com.databricks.spark.sql.perf.tpcds.TPCDSTables
import org.apache.hadoop.fs.Path
import org.apache.spark.sql.{SaveMode, SparkSession}
import org.apache.spark.util.SerializableConfiguration

object TransformFlatData {
  def main(args: Array[String]): Unit = {
    val it = args.iterator
    val srcLocation = it.next()
    val dsdgenDir = it.next()
    val scaleFactor = it.next()
    val numPartitions = it.next().toInt
    val DB = it.next()
    val dstLocation = it.next()

    val spark = Utility.createSparkSession(getClass.getName)

    val configuration = spark.sparkContext.hadoopConfiguration

    val tables = new TPCDSTables(spark.sqlContext,
      dsdgenDir = dsdgenDir,
      scaleFactor = scaleFactor)

    val path = new Path(srcLocation)
    val fs = path.getFileSystem(configuration)
    fs.mkdirs(path)

    spark.sql(s"drop database if exists $DB cascade")
    spark.sql(s"create database $DB")
    spark.sql(s"use $DB")

    tables.tables.foreach(table => {
      println(s"Creating table ${table.name}")
      val tableLocation = s"${srcLocation}/${table.name}"
      val data = spark.read.schema(table.schema).options(Map("sep" -> "|", "header" -> "false")).csv(tableLocation)
      val tempTableName = s"${table.name}_text"
      data.createOrReplaceTempView(tempTableName)
      val writer = if (table.partitionColumns.nonEmpty) {
        val columnString = data.schema.fields.map(_.name).mkString(",")
        val partitionColumnString = table.partitionColumns.mkString(",")
        val grouped = spark.sql(s"SELECT ${columnString} FROM ${tempTableName} DISTRIBUTE BY ${partitionColumnString}")
        grouped.write.partitionBy(table.partitionColumns: _*)
      } else {
        data.write
      }
      writer.format("delta").mode(SaveMode.Overwrite).saveAsTable(s"${table.name}")
    })
  }
}
