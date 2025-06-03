# Settings ##############################
ANDROID_HOME        = /home/i0ne/Programming/3rd-party/android/sdk
JAVA_HOME           = /usr/lib/jvm/jdk-21.0.4-oracle-x64
APP_LABEL           = Application
COMPANY             = example
PROJECT             = project
KEYSTORE_PASS       = $(PROJECT)
KOTLIN_STDLIB       = /home/i0ne/Software/kotlin/kotlinc/lib/kotlin-stdlib.jar
BUILD_TOOLS_VERSION = 34.0.0
API_VERSION         = 29
JVM_VERSION         = 17
#########################################

BUILD_TOOLS   = $(ANDROID_HOME)/build-tools/$(BUILD_TOOLS_VERSION)
SRC_PATH      = src/com/$(COMPANY)/$(PROJECT)
PACKAGE_NAME  = com.$(COMPANY).$(PROJECT)
ANDROID_LIB   = $(ANDROID_HOME)/platforms/android-$(API_VERSION)/android.jar
RESOURCES     = $(shell find res -type f)
RESOURCE_OBJS = $(addsuffix .flat,$(subst res_,build/res/,$(subst /,_,$(RESOURCES)))) 

.PHONY: clean init

all: build/$(KEYSTORE_PASS).keystore build/dex/kotlin-stdlib.dex $(RESOURCE_OBJS)
	mkdir -p build/classes
	kotlinc -jvm-target $(JVM_VERSION) -cp $(ANDROID_LIB):build/classes $(SRC_PATH) -d build/classes
	$(JAVA_HOME)/bin/javac -source $(JVM_VERSION) -target $(JVM_VERSION) $(SRC_PATH)/R.java -d build/classes
	
	mkdir -p build/dex
	find build/classes -name *.class -printf "%p " | xargs $(BUILD_TOOLS)/d8 --lib $(ANDROID_LIB) --output build/dex build/dex/kotlin-stdlib.dex
	zip -uj build/$(PROJECT).apk build/dex/classes.dex
	
	$(BUILD_TOOLS)/zipalign -f 4 ./build/$(PROJECT).apk ./build/tmp.apk
	mv ./build/tmp.apk ./build/$(PROJECT).apk
	
	$(BUILD_TOOLS)/apksigner sign --ks ./build/$(KEYSTORE_PASS).keystore --out ./build/tmp.apk --ks-pass pass:$(KEYSTORE_PASS) ./build/$(PROJECT).apk
	mv ./build/tmp.apk ./build/$(PROJECT).apk
	
	$(ANDROID_HOME)/platform-tools/adb install -r ./build/$(PROJECT).apk

# Build resources: layouts, images, etc.
$(RESOURCE_OBJS): $(RESOURCES)
	mkdir -p build/res
	$(BUILD_TOOLS)/aapt2 compile $(RESOURCES) -o build/res
	$(BUILD_TOOLS)/aapt2 link -I $(ANDROID_LIB) --java src --manifest AndroidManifest.xml build/res/* -o build/$(PROJECT).apk

# Build kotlin stdlib. Android has only java stdlib
build/dex/kotlin-stdlib.dex:
	mkdir -p build/dex
	$(BUILD_TOOLS)/d8 --lib $(ANDROID_LIB) $(KOTLIN_STDLIB) --output build/dex
	mv build/dex/classes.dex build/dex/kotlin-stdlib.dex

# Create keystore-pass
build/$(KEYSTORE_PASS).keystore:
	mkdir -p build
	$(JAVA_HOME)/bin/keytool -genkeypair -validity 1000 -dname "CN=$(KEYSTORE_PASS),O=Android,C=ES" -keystore build/$(KEYSTORE_PASS).keystore -storepass $(KEYSTORE_PASS) -keypass $(KEYSTORE_PASS) -alias projectKey -keyalg RSA


# Generate basic manifest, activity, layout
init:
	@echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>"                                     > AndroidManifest.xml
	@echo "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\""        >> AndroidManifest.xml
	@echo "    package=\"$(PACKAGE_NAME)\""                                               >> AndroidManifest.xml
	@echo "    android:versionCode=\"1\" android:versionName=\"1.0\" >"                   >> AndroidManifest.xml
	@echo "    <uses-sdk android:minSdkVersion=\"23\" android:targetSdkVersion=\"34\"/>"  >> AndroidManifest.xml
	@echo "    <application android:label=\"$(APP_LABEL)\">"                              >> AndroidManifest.xml
	@echo "        <activity android:name=\"$(PACKAGE_NAME).MainActivity\""               >> AndroidManifest.xml
	@echo "            android:theme=\"@android:style/Theme.NoTitleBar.Fullscreen\""      >> AndroidManifest.xml
	@echo "            android:exported=\"true\">"                                        >> AndroidManifest.xml
	@echo "            <intent-filter>"                                                   >> AndroidManifest.xml
	@echo "                <action android:name=\"android.intent.action.MAIN\"/>"         >> AndroidManifest.xml
	@echo "                <category android:name=\"android.intent.category.LAUNCHER\"/>" >> AndroidManifest.xml
	@echo "            </intent-filter>"                                                  >> AndroidManifest.xml
	@echo "       </activity>"                                                            >> AndroidManifest.xml
	@echo "    </application>"                                                            >> AndroidManifest.xml
	@echo "</manifest>"                                                                   >> AndroidManifest.xml
	
	mkdir -p $(SRC_PATH)
	@echo "package $(PACKAGE_NAME)"                                   > $(SRC_PATH)/MainActivity.kt
	@echo "import android.app.Activity"                              >> $(SRC_PATH)/MainActivity.kt
	@echo "import android.os.Bundle"                                 >> $(SRC_PATH)/MainActivity.kt
	@echo "class MainActivity : Activity() {"                        >> $(SRC_PATH)/MainActivity.kt
	@echo "    override fun onCreate(savedInstanceState: Bundle?) {" >> $(SRC_PATH)/MainActivity.kt
	@echo "        super.onCreate(savedInstanceState)"               >> $(SRC_PATH)/MainActivity.kt
	@echo "        setContentView(R.layout.simple_layout)"           >> $(SRC_PATH)/MainActivity.kt
	@echo "    }"                                                    >> $(SRC_PATH)/MainActivity.kt
	@echo "}"                                                        >> $(SRC_PATH)/MainActivity.kt
	
	mkdir -p res/layout
	@echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>"                                  > res/layout/simple_layout.xml
	@echo "<LinearLayout xmlns:android=\"http://schemas.android.com/apk/res/android\"" >> res/layout/simple_layout.xml
	@echo "              android:layout_width=\"fill_parent\""                         >> res/layout/simple_layout.xml
	@echo "              android:layout_height=\"fill_parent\""                        >> res/layout/simple_layout.xml
	@echo "              android:orientation=\"vertical\" >"                           >> res/layout/simple_layout.xml
	@echo "    <View android:id=\"@+id/simple_view\""                                  >> res/layout/simple_layout.xml
	@echo "          android:layout_width=\"fill_parent\""                             >> res/layout/simple_layout.xml
	@echo "          android:layout_height=\"fill_parent\"/>"                          >> res/layout/simple_layout.xml
	@echo "</LinearLayout>"                                                            >> res/layout/simple_layout.xml

clean:
	rm -r build
