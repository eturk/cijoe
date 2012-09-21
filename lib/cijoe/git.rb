class CIJoe
  class Git
    attr_reader :project_path

    def initialize(project_path)
      @project_path = project_path
    end

    def branch_sha(branch)
      `cd #{@project_path} && git rev-parse origin/#{branch}`.chomp
    end

    def update
      `cd #{@project_path} && git fetch origin && git reset --hard origin/#{git_branch}`
      run_hook "after-reset"
    end

    def tag(sha, name)
      `cd #{@project_path} && git tag #{name} #{sha}`
    end

    def tag_sha(name)
      `cd #{@project_path} && git rev-parse #{name}`.chomp
    end

    def user_and_project
      Config.remote(@project_path).origin.url.to_s.chomp('.git').split(':')[-1].split('/')[-2, 2]
    end

    def branch
      branch = Config.cijoe(@project_path).branch.to_s
      if branch.empty?
        'master'
      else
        branch
      end
    end
  end
end
