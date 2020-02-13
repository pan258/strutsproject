node {
    def app

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build("lil00/strutsproject:${env.struts2_version}_build", "--build-arg owner_email=${env.owner_email} --build-arg struts2_version=${env.struts2_version} --build-arg tomcat_version=${env.tomcat_version} .")
        echo app.id
        // echo app.parsedId
    }

    stage('Scan image') {
        twistlockScan ca: '', cert: '', compliancePolicy: 'warn', dockerAddress: 'unix:///var/run/docker.sock', ignoreImageBuildTime: true, image: "tl_demo/struts2_demo:${env.struts2_version}_build", key: '', logLevel: 'true', policy: 'warn', requirePackageUpdate: true, timeout: 10
    }
    
    stage('Publish scan results') {
        twistlockPublish ca: '', cert: '', dockerAddress: 'unix:///var/run/docker.sock', ignoreImageBuildTime: true, image: "tl_demo/struts2_demo:${env.struts2_version}_build", key: '', logLevel: 'true', timeout: 10
    }
    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * For this example, we're using a Volkswagen-type approach ;-) */

        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        try {
            docker.withRegistry('lil00/strutsproject') {
                app.push("${env.BUILD_NUMBER}")
                app.push("${env.struts2_version}")
                app.push("latest")
            }
        }catch(error) {
            echo "First build failed, let's retry if accepted"
            retry(5) {
                docker.withRegistry('lil00/strutsproject') {
                    app.push("${env.BUILD_NUMBER}")
                    app.push("${env.struts2_version}")
                    app.push("latest")
                }
            }
        }
    }
}
