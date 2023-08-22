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
      val path = s"${queriesDir}/query_0.sql"
      // read path, split by ";"
      val queries = scala.io.Source.fromFile(path).mkString.split(";")
      // for each line, sqlContext.sql(line)
      queries.zipWithIndex.foreach { case (query, i) =>
        println(s"Testing: \n${query}")
        val df = spark.sql(query)
        Utility.writeCsvFile(df, s"${i}.csv")
      }
    }
  }
}
