package com.databricks.spark.sql.perf.tpcds

import org.apache.hadoop.fs.Path
import org.apache.spark.sql.{SaveMode, SparkSession}
import org.apache.spark.util.SerializableConfiguration

import java.io.PrintWriter

object TransformFlatData {
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

    val configuration = spark.sparkContext.hadoopConfiguration
    val s_configuration = new SerializableConfiguration(configuration)

    val tables = new TPCDSTables(spark.sqlContext,
      dsdgenDir = dsdgenDir,
      scaleFactor = scaleFactor)

    val path = new Path(srcLocation)
    val fs = path.getFileSystem(configuration)
    fs.mkdirs(path)
    val dataGenerator = tables.dataGenerator

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
      writer.format("parquet").mode(SaveMode.Overwrite).save(s"${dstLocation}/${table.name}")
    })
  }
}
