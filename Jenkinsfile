pipeline {
    agent any
    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 30, unit: 'MINUTES')
    }
    parameters {
        booleanParam(name: 'SIMULATE_FAILURE', defaultValue: false,
            description: 'Учебная ошибка на этапе тестирования')
        string(name: 'NOTIFY_EMAIL', defaultValue: 'student@example.test',
            description: 'Адрес в локальном учебном SMTP-сервере')
    }
    environment {
        APP_NAME = 'devops-practice4'
        DISABLE_AUTH = 'true'
        DEMO_ACCESS_KEY = credentials('practice4-demo-key')
    }
    stages {
        stage('Build') {
            steps {
                echo "Проект: ${env.APP_NAME}; сборка: ${env.BUILD_NUMBER}"
                echo "Учебный режим DISABLE_AUTH=${env.DISABLE_AUTH}"
                sh 'test -n "$DEMO_ACCESS_KEY" && echo "Учётные данные доступны (значение скрыто)"'
                sh 'sh scripts/build.sh'
            }
        }
        stage('Test') {
            steps {
                sh 'sh scripts/test.sh'
                script {
                    if (params.SIMULATE_FAILURE) {
                        error('Преднамеренная учебная ошибка для проверки post failure')
                    }
                }
            }
        }
        stage('Deploy to Staging') {
            steps {
                sh 'sh deploy staging'
                sh 'sh smoke-tests staging'
            }
        }
        stage('Approval') {
            steps {
                input message: 'Staging проверен. Выполнить учебный деплой в production?',
                    ok: 'Разрешить деплой'
            }
        }
        stage('Deploy to Production') {
            steps {
                sh 'sh deploy prod'
                sh 'sh smoke-tests prod'
            }
        }
    }
    post {
        always {
            echo 'Завершение конвейера: сохранение результатов'
            archiveArtifacts artifacts: 'dist/**, deployments/**', allowEmptyArchive: true
        }
        success {
            echo 'Все этапы CI/CD выполнены успешно'
        }
        failure {
            echo 'Сборка завершилась ошибкой. Отправляется учебное уведомление'
            mail to: params.NOTIFY_EMAIL,
                subject: "${env.JOB_NAME}: сборка #${env.BUILD_NUMBER} завершилась ошибкой",
                body: "Учебное уведомление Jenkins. Журнал сборки: ${env.BUILD_URL}console"
        }
        changed {
            echo 'Состояние конвейера изменилось по сравнению с предыдущей сборкой'
        }
        fixed {
            echo 'Работоспособность восстановлена после неуспешной сборки'
        }
        cleanup {
            echo 'Очистка рабочей области после сохранения артефактов'
            deleteDir()
        }
    }
}
