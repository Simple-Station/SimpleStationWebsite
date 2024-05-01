require "uri"
require "net/http"

module Jekyll
    class InsertIconTag < Liquid::Tag
        ICON_DOMAIN_KEY = "icon_domain"
        ICON_REPLACEMENT = "{icon}"
        ICON_TAG = "is_icon"

        def initialize(tag_name, text, tokens)
            super
            @input = text.split(" ")
        end

        def render(context)
            text = context[@input[0].strip] ? context[@input[0].strip] : @input[0].strip
            color = @input[1] ? context[@input[1].strip] ? context[@input[1].strip] : @input[1].strip : ""

            domain_format = context["site"][ICON_DOMAIN_KEY]
            if domain_format == nil
                raise "Key '#{ICON_DOMAIN}' is not set in Jekyll config."
            end

            if domain_format.include?(ICON_REPLACEMENT)
                domain = domain_format.sub(ICON_REPLACEMENT, text) + color
            else
                domain = domain_format + text + "/" + color
            end

            found = false
            for file in context["site"]["static_files"]
                #TODO: I don't love that this uses the default frontmatters. More elegant solution coming some time.
                if file.data[ICON_TAG] && file.name.delete_suffix(file.extname) == text
                    domain = file.url
                    found = true
                    break
                end
            end

            if !found && context["site"]["env"] == "production"
                response = Net::HTTP.get_response(URI(domain))

                if response.code == "404"
                    raise "Could not find a local backup for non-online avaliable icon '#{text}'! Ensure that the icon exists and is tagged as '#{ICON_TAG}'."
                end
            end
            
            return "#{domain}"
        end
    end
end

Liquid::Template.register_tag("insert_icon", Jekyll::InsertIconTag)