

module Fastlane
    module Actions
        module SharedValues
            UPLOAD_DSYM_TO_APPTICS_CUSTOM_VALUE = :UPLOAD_DSYM_TO_APPTICS_CUSTOM_VALUE
        end

        class UploadDsymToAppticsAction < Action

            def self.run(params)

                if params[:APP_VERSION] && params[:MODE_VALUE] && params[:PLATFORM_VALUE] && params[:BUNDLE_ID] && params[:BUILD_VERSION] && params[:DSYM_FILE_PATH] && options_from_info_plist(params[:CONFIG_FILE_PATH]) != nil
                    dsym_zip_file = params[:DSYM_FILE_PATH]
                    app_version = params[:APP_VERSION]
                    build_version = params[:BUILD_VERSION]
                    mode_value = params[:MODE_VALUE]
                    platform_value = params[:PLATFORM_VALUE]
                    bundleid = params[:BUNDLE_ID]
                    config_file = options_from_info_plist(params[:CONFIG_FILE_PATH])
                    upload(config_file, dsym_zip_file,app_version,build_version,mode_value,platform_value,bundleid)

                end
            end
            def self.valid_json?(string)
                  !!JSON.parse(string)
                rescue JSON::ParserError
                  false
                end

            def self.upload(apptics_config, dsym_zip_file,app_version,build_version,mode_value,platform_value,bundleid)
                api_key = apptics_config[:API_KEY]
                server_url = apptics_config[:SERVER_URL]
                bundle_id = apptics_config[:BUNDLE_ID]

                puts "bundleid #{bundleid}"
                puts "mode_value #{mode_value}"
                puts "platform_value #{platform_value}"
#check mode value empty or nil
                if mode_value.nil? || mode_value.empty?
                   puts "mode_value is empty or nil "
                   mode_value = 1
                else
                   puts "mode_value is not empty"
                end
#check platform value empty or nil

                if platform_value.nil? || platform_value.empty?
                   puts "platform_value is empty or nil "
                   platform_value = 'iOS'

                else
                   puts "platform_value is not empty"
                end
  #check bundleid from config file is equals to the fastfile bundleid

                if bundleid == bundle_id
                else
                  UI.error "ABORTED! BUNDLE_ID mismatch replace #{bundle_id} to #{bundleid} "
                  exit(true)
                end
                puts "mode_value #{mode_value}"
                puts"dsym_zip_file #{dsym_zip_file}"
                puts "api_key #{api_key}"

                server_url = "#{server_url}/api/janalytic/v3/addDsymfile?mode=#{mode_value}&platform=#{platform_value}&identifier=#{bundle_id}&appversion=#{app_version}&host=&remoteaddress=&buildversion=#{build_version}&minosversion=&frameworkversion=#{Apptics::VERSION}"


                puts "server_url #{server_url}"

                url = URI.parse(server_url)
                File.open(dsym_zip_file) do |zip|
                    req = Net::HTTP::Post.new(url)
                    form_data = [['dsymfile', zip]]
                    req.set_form form_data, 'multipart/form-data'
                    req['zak']=api_key
                    res = Net::HTTP.start(url.host, url.port, use_ssl: true, open_timeout:60, read_timeout: 300) do |http|
                        http.request(req)
                    end

                    # Status
                    puts res.code       # => '200'
                    puts res.class.name # => 'HTTPOK'
                    puts res.body
                    # Body
                    if valid_json?(res.body)
                        data_hash = JSON.parse(res.body)
                        puts "dSYM upload status : #{data_hash['result']}"
                        if data_hash["result"] == "success"
                            puts "data : #{data_hash['data']}"
                        else
                            puts "error_message : #{data_hash['error_message']}"
                        end
                    else
                        puts res.body
                    end
                end
            end

            #####################################################
            # @!group Documentation
            #####################################################

            def self.description
                "A short description with <= 80 characters of what this action does"
            end

            def self.details
                # Optional:
                # this is your chance to provide a more detailed description of this action
                "You can use this action to do cool things..."
            end

            def self.available_options
                # Define all options your action supports.

                # Below a few examples
                [
                FastlaneCore::ConfigItem.new(key: :APP_VERSION,
                                             env_name: "APP_VERSION", # The name of the environment variable
                                             description: "App Version needed for UploadDsymToAppticsAction", # a short description of this parameter
                                             verify_block: proc do |value|
                                             UI.user_error!("No App Version for UploadDsymToAppticsAction given") unless (value and not value.empty?)
                                             end),

                                             FastlaneCore::ConfigItem.new(key: :DSYM_FILE_PATH,
                                                                          env_name: "DSYM_FILE_PATH", # The name of the environment variable
                                                                          description: "DSYM path for UploadDsymToAppticsAction", # a short description of this parameter
                                                                          verify_block: proc do |value|
                                                                          UI.user_error!("No DSYM path for UploadDsymToAppticsAction given, pass using `api_token: 'token'`") unless (value and not value.empty?)
                                                                          # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                                                          end),
                                                                          FastlaneCore::ConfigItem.new(key: :MODE_VALUE,
                                                                                                       env_name: "MODE_VALUE", # The name of the environment variable
                                                                                                       description: "mode for UploadDsymToAppticsAction", # a short description of this parameter
                                                                                                       verify_block: proc do |value|
                                                                                                       #UI.user_error!("mode for UploadDsymToAppticsAction given, pass using `api_token: 'token'`") unless (value and not value.empty?)
                                                                                                       # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                                                                                       end),
                                                                          FastlaneCore::ConfigItem.new(key: :PLATFORM_VALUE,
                                                                                                      env_name: "PLATFORM_VALUE", # The name of the environment variable
                                                                                                      description: "platform for UploadDsymToAppticsAction", # a short description of this parameter
                                                                                                      verify_block: proc do |value|
                                                                                                      #UI.user_error!("mode for UploadDsymToAppticsAction given, pass using `api_token: 'token'`") unless (value and not value.empty?)
                                                                                                      # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                                                                                    end),
                                                                                                    FastlaneCore::ConfigItem.new(key: :BUNDLE_ID,
                                                                                                                                env_name: "BUNDLE_ID", # The name of the environment variable
                                                                                                                                description: "bundleid for UploadDsymToAppticsAction", # a short description of this parameter
                                                                                                                                verify_block: proc do |value|
                                                                                                                                #UI.user_error!("mode for UploadDsymToAppticsAction given, pass using `api_token: 'token'`") unless (value and not value.empty?)
                                                                                                                                # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                                                                                                              end),

                                                                          FastlaneCore::ConfigItem.new(key: :BUILD_VERSION,
                                                                                                       env_name: "BUILD_VERSION]", # The name of the environment variable
                                                                                                       description: "Build version for UploadDsymToAppticsAction", # a short description of this parameter
                                                                                                       verify_block: proc do |value|
                                                                                                       UI.user_error!("No Build version for UploadDsymToAppticsAction given") unless (value and not value.empty?)
                                                                                                       # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                                                                                       end),

                                                                                                       FastlaneCore::ConfigItem.new(key: :CONFIG_FILE_PATH,
                                                                                                                                    env_name: "CONFIG_FILE_PATH", # The name of the environment variable
                                                                                                                                    description: "Config File for UploadDsymToAppticsAction", # a short description of this parameter
                                                                                                                                    verify_block: proc do |value|
                                                                                                                                    UI.user_error!("No Config File for UploadDsymToAppticsAction given") unless (value and not value.empty?)
                                                                                                                                    # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                                                                                                                  end)

                                                                                                                                    ]
            end

            def self.output
                # Define the shared values you are going to provide
                # Example
                [
                ['UPLOAD_DSYM_TO_APPTICS_CUSTOM_VALUE', 'A description of what this value contains']
                ]
            end

            def self.options_from_info_plist file_path

                plist_getter = Fastlane::Actions::GetInfoPlistValueAction
                api_key = plist_getter.run(path: file_path, key: "API_KEY")
                server_url = plist_getter.run(path: file_path, key: "SERVER_URL")
                app_version_meta = plist_getter.run(path: file_path, key: "APP_VERSION_META")
                bundle_id = plist_getter.run(path: file_path, key: "BUNDLE_ID")

                {
                    API_KEY: api_key,
                    SERVER_URL:server_url,
                    BUNDLE_ID:bundle_id,
                    APP_VERSION_META: app_version_meta
                }


            end



            def self.return_value
                # If your method provides a return value, you can describe here what it does
            end

            def self.authors
                # So no one will ever forget your contribution to fastlane :) You are awesome btw!
                ["Your GitHub/Twitter Name"]
            end

            def self.is_supported?(platform)
                [:ios, :mac, :tvos].include?(platform)
            end
        end
    end
end
