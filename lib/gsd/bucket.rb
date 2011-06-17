module GSD
  class Client
    def list_buckets(options = {})
      xml = get(nil, '/', options)
      return xml if options[:raw]

      doc = LibXML::XML::Document.string(xml)
      doc.root.namespaces.default_prefix = 'aws'

      doc.find("//aws:Bucket").map do |bucket_node|
        attrs = {}
        attrs[:name] = bucket_node.find_first("./aws:Name").content
        attrs[:created_at] = Time.parse(bucket_node.find_first("./aws:CreationDate").content)
        Bucket.new(attrs)
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
      xml = get(bucket, '/', options)
      return xml if options[:raw]

      doc = LibXML::XML::Document.string(xml)
      doc.root.namespaces.default_prefix = 'aws'

      list_bucket_result = doc.find_first("/aws:ListBucketResult")
      bucket_name = list_bucket_result.find_first("./aws:Name").content
      truncated = list_bucket_result.find_first("./aws:IsTruncated").content == "true"

      entries = doc.find("//aws:Contents").map do |contents_node|
        attrs = {}
        attrs[:name] = contents_node.find_first("./aws:Key").content
        attrs[:last_modified] = Time.parse(contents_node.find_first("./aws:LastModified").content)
        attrs[:etag] = contents_node.find_first("./aws:ETag").content
        attrs[:size] = contents_node.find_first("./aws:Size").content.to_i
        attrs[:storage_class] = contents_node.find_first("./aws:StorageClass").content
        attrs[:owner_id] = contents_node.find_first("./aws:Owner/aws:ID").content

        Object.new(attrs)
      end

      if truncated
        next_marker = list_bucket_result.find_first("./aws:NextMarker").content

        more_entries = get_bucket(bucket, {:params => {:marker => next_marker}}).entries
        entries.concat(more_entries)
      end

      Bucket.new({name: bucket_name, entries: entries})
    end
    
    def delete_bucket(bucket, options = {})
      delete(bucket, '/', options)
    end
  end

  class Bucket
    attr_reader :name, :created_at, :entries

    def initialize(options = {})
      @name = options[:name]
      @created_at = options[:created_at]
      @entries = options[:entries]
    end

    def to_s
      "Bucket[name=#{name}, entries=#{entries.size}]"
    end
  end
end
