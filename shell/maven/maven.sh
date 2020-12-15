#!/bin/bash

# 创建基本的一个项目
mvn archetype:create -DgroupId=org.sonatype.mavenbook.ch03 -DartifactId=simple -DpackageName=org.sonatype.mavenbook
mvn archetype:create -DgroupId=org.sonatype.mavenbook.ch05 -DartifactId=simple-webapp -DpackageName=org.sonatype -DarchetypeArtifactId=maven-archetype-webapp

# 查看help插件的描述
mvn help:describe -Dplugin=help
## help插件的完全描述
mvn help:describe -Dplugin=help -Dfull

# 查看帮助
help:active-profiles
    # 列出当前构建中活动的Profile（项目的，用户的，全局的）。
help:effective-pom
    # 显示当前构建的实际POM，包含活动的Profile。
help:effective-settings
    #打印出项目的实际settings, 包括从全局的settings和用户级别settings继承的配置。
help:describe
    # 描述插件的属性。它不需要在项目目录下运行。但是你必须提供你想要描述插件的 groupId 和 artifactId。

# 插件 goal的执行
mvn resources:resources \
compiler:compile \
resources:testResources \
compiler:testCompile \
surefire:test \
jar:jar

## 当前项目依赖
mvn dependency:resolve
mvn dependency:tree



<dependency>
<groupId>org.apache.geronimo.specs</groupId>
<artifactId>geronimo-servlet_2.4_spec</artifactId>
<version>1.1.1</version>
<scope>provided</scope>
</dependency>

<dependency>
<groupId>org.apache.geronimo.specs</groupId>
<artifactId>geronimo-jsp_2.0_spec</artifactId>
<version>1.1</version>
<scope>provided</scope>
</dependency>



