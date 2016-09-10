require 'test_helper'

class CompassTest < Minitest::Test
  COMPASS_CMD = 'compass create tmp/new-compass-project -r bootstrap --using bootstrap --trace --force'

  def test_create_project
    command = [
        'rm -rf tmp/new-compass-project;',
        COMPASS_CMD
    ].join(' ')
    success = silence_stdout_if(!ENV['VERBOSE']) { system(command) }
    assert success, 'Compass project creation failed!'
  end
end
