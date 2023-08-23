package org.pacman.tpcds

import org.apache.spark.sql.SparkSession
import org.pacman.tpcds.Utility.executePhase

object PowerTest {
  def main(args: Array[String]): Unit = {
    val it = args.iterator
    val queriesDir = it.next()
    val DB = it.next()

    executePhase(DB, "PowerTest") {
      val spark = Utility.createSparkSession(getClass.getName)

      spark.sql(s"use ${DB}")
      Utility.loadQueries(queriesDir, 0).zipWithIndex.foreach { case (query, i) =>
        println(s"Testing: \n${query}")
        val df = spark.sql(query)
        Utility.writeCsvFile(df, s"${i}.csv")
      }
    }
  }
}
