module Jekyll
    class RandomImageTag < Liquid::Tag
        BASE_DOMAIN = "https://source.unsplash.com/random/"

        def initialize(tag_name, text, tokens)
            super
            @input = text.split(", ")
        end

        def render(context)
            search_terms = @input.map { |i| context[i].to_s.delete(" ") }.join(",")

            return "#{BASE_DOMAIN}?#{search_terms}"
        end
    end
end

Liquid::Template.register_tag("random_image", Jekyll::RandomImageTag)
