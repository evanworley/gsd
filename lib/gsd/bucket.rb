module GSD
  class Client
    def list_buckets(options = {})
      xml = get(nil, '/', options)
      return xml if options[:raw]

      doc = LibXML::XML::Document.string(xml)
      doc.root.namespaces.default_prefix = 'aws'

      doc.find("//aws:Bucket").map do |bucket_node|
        Bucket.new(bucket_node)
      end
    end

    def each_bucket(options = {})
      list_buckets(options).each do |bucket|
        yield bucket
      end
    end
    
    def create_bucket(bucket, options = {})
      put(bucket, '/', options)
    end
    
    def get_bucket(bucket, options = {})
      get(bucket, '/', options)
    end
    
    def delete_bucket(bucket, options = {})
      delete(bucket, '/', options)
    end
  end

  class Bucket
    attr_reader :name, :created_at

    def initialize(bucket_node)
      @name = bucket_node.find_first("./aws:Name").content
      @creation_date = Time.parse(bucket_node.find_first("./aws:CreationDate").content)
    end
  end
end
