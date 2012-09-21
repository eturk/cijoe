class CIJoe
  class Git
    attr_reader :project_path

    class InvalidGitRepo < StandardError
      def to_s
        'Invalid git repo path.'
      end
    end

    def initialize(project_path)
      @project_path = project_path
    end

    def branch_sha(branch)
      `cd #{@project_path} && git rev-parse origin/#{branch}`.chomp
    end

    def update
      `cd #{@project_path} && git fetch origin && git reset --hard origin/#{branch}`
    end

    def tag(sha, name)
      `cd #{@project_path} && git tag -f #{name} #{sha}`
    end

    def rev_parse(name)
      `cd #{@project_path} && git rev-parse #{name}`.chomp
    end
    alias :tag_sha :rev_parse

    def note(sha, text)
      `cd #{@project_path} && git notes --ref=build add -m "#{text}" #{sha}`.chomp
    end

    def note_message(sha)
      `cd #{@project_path} && git notes --ref=build show #{sha}`.chomp
    end

    def user_and_project
      url = git_remote_url
      unless url.empty?
        return url.chomp('.git').split(':')[-1].split('/')[-2, 2]
      else
        raise InvalidGitRepo
      end
    end

    def branch
      branch = Config.cijoe(@project_path).branch.to_s
      if branch.empty?
        'master'
      else
        branch
      end
    end

    private
    def git_remote_url
      Config.remote(@project_path).origin.url.to_s
    end
  end
end
