require 'spec_helper_acceptance'

describe 'openstacklib class' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include openstack_integration
      include openstack_integration::repos
      include openstack_integration::rabbitmq

      # openstacklib resources
      include openstacklib::openstackclient

      ::openstacklib::messaging::rabbitmq { 'beaker':
        userid   => 'beaker',
        is_admin => true,
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe 'test rabbitmq resources' do
      it 'should list rabbitmq beaker resources' do
        shell('rabbitmqctl list_users') do |r|
          expect(r.stdout).to match(/^beaker/)
          expect(r.stdout).not_to match(/^guest/)
          expect(r.exit_code).to eq(0)
        end

        shell('rabbitmqctl list_permissions') do |r|
          expect(r.stdout).to match(/^beaker\t\.\*\t\.\*\t\.\*$/)
          expect(r.exit_code).to eq(0)
        end
      end
    end

  end
end
