class ErbInterpreter < OpenStruct
  def self.render_from_hash(t, h)
    ErbInterpreter.new(h).render(t)
  end

  def render(template)
    ERB.new(template).result(binding)
  end
end
