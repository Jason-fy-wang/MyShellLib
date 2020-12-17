#!/bin/bash

# 创建基本的一个项目
mvn archetype:create -DgroupId=org.sonatype.mavenbook.ch03 -DartifactId=simple -DpackageName=org.sonatype.mavenbook
mvn archetype:create -DgroupId=org.sonatype.mavenbook.ch05 -DartifactId=simple-webapp -DpackageName=org.sonatype -DarchetypeArtifactId=maven-archetype-webapp
# 创建 maven插件项目
mvn archetype:create -DgroupId=org.sonatype.mavenbook.plugins -DartifactId=first-maven-plugin -DarchetypeGroupId=org.apache.maven.archetypes -DarchetypeArtifactId=maven-archetype-mojo
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

mvn -ff  :最快失败模式：Maven会在遇到第一个失败的时候失败（停止）。
mvn -fae :最后失败模式：Maven会在构建最后失败（停止）。如果Maven refactor中一个失败了，Maven会继续构建其它项目，并在构建最后报告失败。
mvn -fn  :从不失败模式：Maven从来不会为一个失败停止，也不会报告失败。


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

# 分析依赖
mvn dependency:analyze

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


# assembly 插件
bin
    假设一个项目构建了一个jar作为它的主构件，bin 描述符用来包裹该主构件和
    项目的LICENSE, README, 和NOTICE文件。我们可以认为这是一个完全自包含项
    目的最可能小的二进制分发包。
jar-with-dependencies
    jar-with-dependencies描述符构建一个带有主项目jar文件和所有项目运行时依
    赖未解开内容的JAR归档文件。外加上适当的Main-Class Manifest条目（在下面
    的“插件配置”讨论），该描述符可以为你的项目生成一个自包含的，可运行的
    jar，即使该项目含有依赖。
project
    project描述符会简单的将你文件系统或者版本控制中的项目目录结构整个的归
    档。当然，target目录会被忽略，目录中的版本控制元数据文件如.svn和CVS目
    录也会被忽略。基本上，该描述符的目的是创建一个解开后就立刻能由Maven构
    建的归档。
src
    src描述符生成一个包含你项目源码，pom.xml文件，以及项目根目录中所
    有LICENSE，README，和NOTICE文件的归档。它类似于project描述符，大部分情况下能生成一个可以被Maven构建的归档。然而，由于它假设所有的源文件和资
    源文件都位于标准的src目录下，它就可能遗漏那些非标准的目录和文件，而这
    些文件往往对构建起着关键作用。
mvn -DdescriptorId=bin assembly:single
mvn -DdescriptorId=jar-with-dependencies assembly:single
mvn -DdescriptorId=project assembly:single
mvn -DdescriptorId=src assembly:single



<plugin>
    <artifactId>maven-assembly-plugin</artifactId>
    <version>2.2-beta-2</version>
    <executions>
        <execution>
            <id>create-executable-jar</id>
            <phase>package</phase>
            <goals>
                <goal>single</goal>
            </goals>
            <configuration>
                <descriptorRefs>
                    <descriptorRef>
                        jar-with-dependencies
                    </descriptorRef>
                </descriptorRefs>
            <archive>
                <manifest>
                    <mainClass>org.sonatype.mavenbook.App</mainClass>
                </manifest>
            </archive>
            </configuration>
        </execution>
    </executions>
</plugin>

<dependency>
    <groupId>org.sonatype.mavenbook.assemblies</groupId>
    <artifactId>first-project</artifactId>
    <version>1.0-SNAPSHOT</version>
    <classifier>project</classifier>
    <type>zip</type>
</dependency>

<dependencySets>
    <dependencySet>
        <outputDirectory>org.sonatype.mavenbook</outputDirectory>
    <outputFileNameMapping>
        ${module.artifactId}.${module.extension}
    </outputFileNameMapping>
    </dependencySet>
</dependencySets>