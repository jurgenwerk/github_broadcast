class TokenMaster
  AVAILABLE_TOKENS = %w(GITHUB_AUTH_1 GITHUB_AUTH_2 GITHUB_AUTH_3 GITHUB_AUTH_4)

  def self.get_token
    ENV.fetch(AVAILABLE_TOKENS.sample)
  end
end
