# frozen_string_literal: true

# Cloud Foundry Java Buildpack
# Copyright 2013-2018 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'
require 'component_helper'
require 'internet_availability_helper'
require 'java_buildpack/container/tomcat/tomcat_external_configuration'

describe JavaBuildpack::Container::TomcatExternalConfiguration do
  include_context 'with component help'

  let(:component_id) { 'tomcat' }

  it 'always detects' do
    expect(component.detect).to eq("tomcat-external-configuration=#{version}")
  end

  it 'does guarantee that internet access is available when downloading',
     app_fixture:   'container_tomcat',
     cache_fixture: 'stub-tomcat-external-configuration.tar.gz' do

    expect_any_instance_of(JavaBuildpack::Util::Cache::InternetAvailability)
      .to receive(:available).with(true, 'The Tomcat External Configuration download location is always accessible')

    component.compile
  end

  it 'extracts Tomcat external configuration files from a GZipped TAR',
     app_fixture:   'container_tomcat',
     cache_fixture: 'stub-tomcat-external-configuration.tar.gz' do

    component.compile

    expect(sandbox + 'conf/context.xml').to exist
    expect(sandbox + 'conf/server.xml').to exist
  end

end
