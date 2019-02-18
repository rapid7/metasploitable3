# require 'rspec'
# require_relative '../libraries/helpers_network'
#
# describe Class.new { include DockerCookbook::DockerHelpers::Network } do
#   subject(:helper) { Class.new { include DockerCookbook::DockerHelpers::Network } }
#   let(:subnets) do
#     %w(
#       192.168.0.0/24
#     )
#   end
#
#   let(:ip_ranges) do
#     %w(
#       192.168.0.31/28
#     )
#   end
#
#   let(:gateways) do
#     %w(
#       192.168.0.34
#     )
#   end
#
#   let(:aux_addresses) do
#     %w(
#       foo=192.168.0.34
#       bar=192.168.0.124
#     )
#   end
#
#   describe '#consolidate_ipam' do
#     subject { described_class.new.consolidate_ipam(subnets, ip_ranges, gateways, aux_addresses) }
#     it 'should have a subnet' do
#       expect(subject).to include(include('Subnet' => '192.168.0.0/24'))
#     end
#
#     it 'should have aux address' do
#       expect(subject).to include(include('AuxiliaryAddresses' => { 'foo' => '192.168.0.34', 'bar' => '192.168.0.124' }))
#     end
#
#     it 'should have gateways' do
#       expect(subject).to include(include('Gateway' => '192.168.0.34'))
#     end
#
#     it 'should have ip range' do
#       expect(subject).to include(include('IPRange' => '192.168.0.31/28'))
#     end
#   end
# end
