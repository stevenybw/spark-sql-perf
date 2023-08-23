// Your sbt build file. Guides on how to write one can be found at
// http://www.scala-sbt.org/0.13/docs/index.html

name := "spark-sql-perf"

organization := "com.databricks"

scalaVersion := "2.12.10"

val sparkVersion = "3.3.2"

libraryDependencies += "com.github.scopt" %% "scopt" % "3.7.1"

libraryDependencies += "com.twitter" %% "util-jvm" % "6.45.0" % "provided"

libraryDependencies += "org.scalatest" %% "scalatest" % "3.0.5" % "test"

libraryDependencies += "io.delta" %% "delta-core" % "2.3.0"

libraryDependencies += "org.yaml" % "snakeyaml" % "1.23"

libraryDependencies += "org.apache.spark" %% "spark-sql" % sparkVersion

libraryDependencies += "org.apache.spark" %% "spark-hive" % sparkVersion

libraryDependencies += "org.apache.spark" %% "spark-mllib" % sparkVersion
