package org.pacman.tpcds

import com.databricks.spark.sql.perf.tpcds.TPCDSTables
import org.apache.hadoop.fs.Path
import org.apache.spark.sql.SparkSession
import org.apache.spark.util.SerializableConfiguration

import java.io.PrintWriter

object GenFlatData {
  def main(args: Array[String]): Unit = {
    val it = args.iterator
    val location = it.next()
    val dsdgenDir = it.next()
    val scaleFactor = it.next()
    val numPartitions = it.next().toInt

    val spark = Utility.createSparkSession(getClass.getName)

    val configuration = spark.sparkContext.hadoopConfiguration
    val s_configuration = new SerializableConfiguration(configuration)

    val tables = new TPCDSTables(spark.sqlContext,
      dsdgenDir = dsdgenDir,
      scaleFactor = scaleFactor)

    val path = new Path(location)
    val fs = path.getFileSystem(configuration)
    fs.mkdirs(path)
    val dataGenerator = tables.dataGenerator

    tables.tables.foreach(table => {
      println(s"Generating table ${table.name}")
      val tableLocation = s"${location}/${table.name}"
      dataGenerator.generate(spark.sparkContext, table.name, numPartitions, scaleFactor).mapPartitionsWithIndex { case (pid, lines) =>
        val linesArray = lines.toArray
        if (linesArray.nonEmpty) {
          val path = new Path(s"${tableLocation}/part${pid}.txt")
          val fs = path.getFileSystem(s_configuration.value)
          val out = fs.create(path, true, 4096)
          val writer = new PrintWriter(out)
          linesArray.foreach(line => {
            writer.println(line)
          })
          writer.flush()
          writer.close()
        }
        Iterator(true)
      }.collect()
    })
  }
}
