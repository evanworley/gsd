module GSD
  class Client
    def put_object(bucket, filename, options = {})
      put(bucket, "/#{filename}", options)
    end
    
    def get_object(bucket, filename, options = {})
      outfile = options.delete(:outfile)
      res = get(bucket, "/#{filename}", options)
      if outfile
        File.open(outfile, 'w') {|f| f.write(res) }
      else
        res
      end
    end
    
    def delete_object(bucket, filename, options = {})
      delete(bucket, "/#{filename}", options)
    end
    
    def get_object_metadata(bucket, filename, options = {})
      head(bucket, "/#{filename}", options)
    end

    class Object
      attr_reader :name, :last_modified, :etag, :size, :storage_class, :owner_id

      def initialize(options = {})
        @name = options[:name]
        @last_modified = options[:last_modified]
        @etag = options[:etag]
        @size = options[:size]
        @storage_class = options[:storage_class]
        @owner_id = options[:owner_id]
     end
   end

  end
end
