TOP=../../..

include $(TOP)/Make.config

MSBUILD_VERBOSITY=
BUILD_CONFIG?=Debug

build:
	$(DOTNET) build /bl $(MSBULD_VERBOSITY)

run: clean
	$(DOTNET) build /bl $(MSBUILD_VERBOSITY) /t:Run

run-msr: clean
	$(DOTNET) build -c $(BUILD_CONFIG) /bl $(MSBUILD_VERBOSITY) /t:Run -r ios-arm64 -p:MtouchExtraArgs=--registrar:managed-static

run-msr-nostrip: clean
	$(DOTNET) build -c $(BUILD_CONFIG) /bl $(MSBUILD_VERBOSITY) /t:Run -r ios-arm64 -p:MtouchExtraArgs=--registrar:managed-static -p:EnableAssemblyILStripping=false

clean:
	rm -rf bin obj