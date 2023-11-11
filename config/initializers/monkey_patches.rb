# # Require all Ruby files in the core_extensions directory by class
# Dir[Rails.root.join('lib', 'core_extensions/*', '*.rb')].each { |f| require f }

# # Apply the monkey patches
# Array.include CoreExtensions::Array
# Hash.include CoreExtensions::Hash