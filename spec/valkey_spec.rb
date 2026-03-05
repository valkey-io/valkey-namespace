require 'spec_helper'

describe Valkey::Namespace do
  let(:valkey) { double('valkey') }
  let(:namespace) { 'test' }
  let(:namespaced) { Valkey::Namespace.new(namespace, valkey: valkey) }

  describe '#initialize' do
    it 'accepts a namespace and valkey connection' do
      expect(namespaced.namespace).to eq('test')
      expect(namespaced.valkey).to eq(valkey)
    end

    it 'creates a new Valkey connection if none provided' do
      allow(Valkey).to receive(:new).and_return(valkey)
      ns = Valkey::Namespace.new('test')
      expect(ns.valkey).to eq(valkey)
    end

    it 'accepts a Proc as namespace' do
      proc_namespace = Proc.new { 'dynamic' }
      ns = Valkey::Namespace.new(proc_namespace, valkey: valkey)
      expect(ns.namespace).to eq('dynamic')
    end
  end

  describe '#set and #get' do
    it 'namespaces the key for set' do
      expect(valkey).to receive(:set).with('test:foo', 'bar')
      namespaced.set('foo', 'bar')
    end

    it 'namespaces the key for get' do
      expect(valkey).to receive(:get).with('test:foo').and_return('bar')
      expect(namespaced.get('foo')).to eq('bar')
    end
  end

  describe '#keys' do
    it 'namespaces the pattern and removes namespace from results' do
      expect(valkey).to receive(:keys).with('test:*').and_return(['test:foo', 'test:bar'])
      expect(namespaced.keys).to eq(['foo', 'bar'])
    end

    it 'accepts a custom pattern' do
      expect(valkey).to receive(:keys).with('test:foo*').and_return(['test:foo1', 'test:foo2'])
      expect(namespaced.keys('foo*')).to eq(['foo1', 'foo2'])
    end
  end

  describe '#del' do
    it 'namespaces all keys' do
      expect(valkey).to receive(:del).with('test:foo', 'test:bar').and_return(2)
      expect(namespaced.del('foo', 'bar')).to eq(2)
    end
  end

  describe '#mget' do
    it 'namespaces all keys' do
      expect(valkey).to receive(:mget).with('test:foo', 'test:bar').and_return(['val1', 'val2'])
      expect(namespaced.mget('foo', 'bar')).to eq(['val1', 'val2'])
    end
  end

  describe '#mset' do
    it 'namespaces alternating keys' do
      expect(valkey).to receive(:mset).with('test:foo', 'val1', 'test:bar', 'val2')
      namespaced.mset('foo', 'val1', 'bar', 'val2')
    end
  end

  describe '#full_namespace' do
    it 'returns the namespace as string' do
      expect(namespaced.full_namespace).to eq('test')
    end

    context 'with nested namespaces' do
      it 'combines namespaces with colons' do
        inner_ns = Valkey::Namespace.new('inner', valkey: namespaced)
        expect(inner_ns.full_namespace).to eq('test:inner')
      end
    end
  end

  describe '#inspect' do
    it 'includes version and namespace' do
      expect(namespaced.inspect).to include('Valkey::Namespace')
      expect(namespaced.inspect).to include('v1.0.0')
      expect(namespaced.inspect).to include('test')
    end
  end

  describe 'administrative commands' do
    it 'warns when using flushall' do
      allow(valkey).to receive(:flushall)
      expect { namespaced.flushall }.to output(/administrative commands/).to_stderr
    end

    it 'raises NoMethodError when deprecations enabled' do
      ns = Valkey::Namespace.new('test', valkey: valkey, deprecations: true)
      expect { ns.flushall }.to raise_error(NoMethodError)
    end
  end

  describe '#warning?' do
    it 'returns true by default' do
      expect(namespaced.warning?).to be true
    end

    it 'can be disabled via option' do
      ns = Valkey::Namespace.new('test', valkey: valkey, warning: false)
      expect(ns.warning?).to be false
    end

    it 'can be disabled via environment variable' do
      ENV['VALKEY_NAMESPACE_QUIET'] = '1'
      ns = Valkey::Namespace.new('test', valkey: valkey)
      expect(ns.warning?).to be false
      ENV.delete('VALKEY_NAMESPACE_QUIET')
    end
  end
end
