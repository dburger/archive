def blah_blah_conditions(scope)
  if params[:whatever]
    scope = scope.find(:conditions => '---')
  end
  scope
end

def gather_em
  methods = methods(/_conditions$/)
  scope = methos.inject(scoped) do |scope, m|
    send(m, scope)
  end
  # and then how to find with scope???
end
