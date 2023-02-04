properties([
            buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '2', numToKeepStr: '10')),
            parameters([
            string(description: 'input the version that you want to build', name: 'version', trim: true),
            //password( description: 'the pwd you use', name: 'password')
            ])
])


timestamps {

    node('linux') {
        stage("print the parameter"){
             OutputPath()
        }

        stage('download source') {
            checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'github', url: 'https://gitee.com/empwang/python_operation.git']])
            def cpath = pwd()
            echo "current path after checkout: $cpath"
        }

        stage('test wrap Ansi color'){
            // 此方式 输出没有任何的颜色, 可能还有点问题
            wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
               sh '''
                python base/basic/do_for.py
                echo -e "\u001B[31m AnsiColorBuildWrapper \u001B[0m"
                '''
            }

            ansiColor("xterm") {
				echo "\u001B[31m Purple \u001B[0m"
			}
        }
    }
}


def OutputPath() {
    def curpath = pwd()
    echo "current path is: $curpath"
    echo "version is: $version"
    //echo "password is: $password"
}
