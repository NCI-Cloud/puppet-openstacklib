#
# Copyright (C) 2014 eNovance SAS <licensing@enovance.com>
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

require 'spec_helper'

describe 'openstacklib::service_validation' do
  let (:title) { 'nova-api' }

  let :required_params do
    {
      :command => 'nova list'
    }
  end

  shared_examples 'openstacklib::service_validation examples' do
    context 'with only required parameters' do
      let :params do
        required_params
      end

      it { should contain_exec("execute #{title} validation").with(
        :path        => '/usr/bin:/bin:/usr/sbin:/sbin',
        :provider    => 'shell',
        :command     => 'nova list',
        :environment => [],
        :refreshonly => false,
        :timeout     => '60',
        :tries       => '10',
        :try_sleep   => '2',
        :logoutput   => 'on_failure',
      )}
    end

    context 'with unless parameter' do
      let :params do
        required_params.merge!({ :unless  => 'pwd' })
      end

      it { should contain_exec("execute #{title} validation").with(
        :path        => '/usr/bin:/bin:/usr/sbin:/sbin',
        :provider    => 'shell',
        :command     => 'nova list',
        :refreshonly => false,
        :timeout     => '60',
        :tries       => '10',
        :try_sleep   => '2',
        :unless      => 'pwd',
      )}
    end

    context 'with onlyif parameter' do
      let :params do
        required_params.merge!({ :onlyif  => 'pwd' })
      end

      it { should contain_exec("execute #{title} validation").with(
        :path        => '/usr/bin:/bin:/usr/sbin:/sbin',
        :provider    => 'shell',
        :command     => 'nova list',
        :refreshonly => false,
        :timeout     => '60',
        :tries       => '10',
        :try_sleep   => '2',
        :onlyif      => 'pwd',
      )}
    end

    context 'with environment parameter' do
      let :params do
        required_params.merge!({ :environment => ['OS_PASSWORD=secret'] })
      end

      it { should contain_exec("execute #{title} validation").with(
        :environment => ['OS_PASSWORD=secret'],
      )}
    end

    context 'when omitting a required parameter command' do
      let :params do
        {}
      end

      it { should raise_error(Puppet::Error) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'openstacklib::service_validation examples'
    end
  end
end
