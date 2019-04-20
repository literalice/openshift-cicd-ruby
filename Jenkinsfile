pipeline {
  agent {
    label 'jenkins-slave-base'
  }
  stages {
    stage('Prepare Build') {
      when {
        expression {
          openshift.withCluster() {
            // 既にアプリケーションのビルド設定がある場合はスキップ
            return !openshift.selector('bc', 'sample-app').exists()
          }
        }
      }
      steps {
        script {
          openshift.withCluster() {
            // アプリケーションのビルド設定がある場合はスキップ
            openshift.newBuild('--name=sample-app', '--image-stream openshift/ruby:2.4', '--binary')
            def app = openshift.newApp('--name=sample-app', '--image-stream=sample-app', '--allow-missing-imagestream-tags')
            app.narrow('dc').expose('--port=8080')
            openshift.selector('svc', [app: 'sample-app']).expose()
          }
        }
      }
    }
    stage('Build') {
      steps {
        script {
          openshift.withCluster() {
            def appBuild = openshift.selector('bc', 'sample-app')
            appBuild.startBuild("--from-dir=.").logs("-f")
          }
        }
      }
    }
    stage('Prepare QA') {
      when {
        expression {
          openshift.withCluster() {
            // 既にアプリケーションのデプロイ設定がある場合はスキップ
            openshift.withProject("qa") {
              return !openshift.selector('dc', 'sample-app').exists()
            }
          }
        }
      }
      steps {
        script {
          openshift.withCluster() {
            openshift.withProject("qa") {
              def app = openshift.newApp('--name=sample-app', '--image-stream=dev/sample-app:beta', '--allow-missing-imagestream-tags')
              app.narrow('dc').expose('--port=8080')
              openshift.selector('svc', [app: 'sample-app']).expose()
            }
          }
        }
      }
    }
  }
}
