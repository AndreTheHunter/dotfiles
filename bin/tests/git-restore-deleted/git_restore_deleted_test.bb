#!/usr/bin/env bb
(let [file (System/getProperty "babashka.file")
      dir (-> (java.io.File. file) .getParentFile .getParentFile .getParentFile)]
  (load-file (str dir "/git-restore-deleted")))
(ns git-restore-deleted-test
  (:require [clojure.test :refer [deftest is testing run-tests]]
            [git-restore-deleted :as m]
            [babashka.fs :as fs]
            [babashka.process :as p]
            [clojure.string :as str]))

(deftest parse-args-test
  (testing "help flag"
    (let [exit-code (atom nil)]
      (with-redefs [m/print-help (fn [] (println "help"))]
        (binding [m/*die* (fn [code _] (reset! exit-code code) (throw (ex-info "exit" {:code code})))]
          (try 
            (m/-main "--help")
            (catch Exception e
              (if (= "exit" (ex-message e))
                nil
                (throw e))))
          (is (= 0 @exit-code)))))))

(deftest logging-test
  (testing "log-skipped"
    (let [sw (java.io.StringWriter.)
          out (binding [*err* sw]
                (binding [m/*verbose* true]
                  (m/log-skipped "path" "reason"))
                (str sw))]
      (is (str/includes? out "Skipped 'path' (reason)")))
    (let [sw (java.io.StringWriter.)
          out (binding [*err* sw]
                (binding [m/*verbose* false]
                  (m/log-skipped "path" "reason"))
                (str sw))]
      (is (str/includes? out "Skipped 'path'"))
      (is (not (str/includes? out "reason"))))))

(let [{:keys [fail error]} (run-tests)]
  (System/exit (if (zero? (+ (or fail 0) (or error 0))) 0 1)))
