{:portal {:dependencies [[djblue/portal "0.59.1"]]}
 :user {:plugins  [[lein-pprint "1.3.2"]
                   [lein-ancient "0.7.0"]]
         :jvm-opts ["-Daether.dependencyCollector.impl=bf"
                    "-Daether.dependencyCollector.bf.threads=64"
                    "-Daether.connector.basic.threads=64"
                    "-Dmaven.wagon.http.pool.maxPerRoute=64"
                    "-Dmaven.wagon.http.pool.maxTotal=64"]}} 
