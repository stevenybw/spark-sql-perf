package org.pacman.tpcds

import org.apache.spark.sql.{DataFrame, SparkSession}
import org.apache.spark.sql.catalyst.csv.{CSVOptions, UnivocityGenerator}
import org.apache.spark.sql.catalyst.expressions.GenericInternalRow
import org.apache.spark.sql.internal.SQLConf

import java.io.PrintWriter

object Utility {
  def writeCsvFile(df: DataFrame, resultFile: String): Unit = {
    val writer = new PrintWriter(resultFile)
    val resultRows = df
      .collect()
      .map(row =>
        new GenericInternalRow(
          (0 until row.length).map(i => row.get(i)).toArray
        )
      )
    val sqlConf = new SQLConf()
    val csvOptions = new CSVOptions(
      Map(),
      columnPruning = sqlConf.csvColumnPruning,
      sqlConf.sessionLocalTimeZone
    )
    val gen = new UnivocityGenerator(df.schema, writer, csvOptions)
    gen.writeHeaders()
    resultRows.foreach(r => gen.write(r))
    gen.flush()
    writer.flush()
    writer.close()
  }

  def createSparkSession(appName: String): SparkSession = {
    SparkSession
      .builder()
      .appName(appName)
      .enableHiveSupport()
      .getOrCreate()
  }
}
