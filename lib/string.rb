class String
    def is_i?
       /\A[-+]?\d+\z/ === self
    end

    def squash
      self.empty? ? nil : self
    end

end