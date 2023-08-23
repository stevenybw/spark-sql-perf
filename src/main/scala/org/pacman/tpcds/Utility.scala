package org.pacman.tpcds

import org.apache.spark.sql.{DataFrame, Encoders, Row, SparkSession}
import org.apache.spark.sql.catalyst.csv.{CSVOptions, UnivocityGenerator}
import org.apache.spark.sql.catalyst.expressions.GenericInternalRow
import org.apache.spark.sql.internal.SQLConf

import java.io.PrintWriter
import org.apache.spark.sql.catalyst.encoders.ExpressionEncoder

object Utility {
  def writeCsvFile(df: DataFrame, resultFile: String): Unit = {
    val writer = new PrintWriter(resultFile)
    val ser = df.encoder.asInstanceOf[ExpressionEncoder[Row]].createSerializer()
    val resultRows = df
      .collect()
      .map(row => ser(row)
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

  def loadQueries(queriesDir: String, stream: Int): Array[String] = {
    val path = s"${queriesDir}/query_${stream}.sql"
    // read path, split by ";"
    val queries = scala.io.Source.fromFile(path).mkString.split(";")
    // for each line, sqlContext.sql(line)
    queries.slice(0, queries.length - 1)
  }

  def executePhase(sf: String, phaseName: String)(v: => Unit): Unit = {
    val name = s"${phaseName}-${sf}"
    val bt = System.currentTimeMillis()
    print(s"[${bt}] Begin the execution of ${name}")
    v
    val et = System.currentTimeMillis()
    print(s"[${et}] End the execution of ${name}")
    val fw = new java.io.FileWriter("phase_log.csv", true)
    fw.write(s"${sf},${phaseName},${bt},${et},${1e-6 * (et - bt)}\n")
    fw.flush()
    fw.close()
  }
}
