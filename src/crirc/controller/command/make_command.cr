module Crirc::Controller::Command::Make
  abstract def puts

  macro make_command(name, *args, &block)
    def {{name.id}}(**args)
      puts _{{name.id}}_command(**args)
    end

    def _{{name.id}}_command(**args)
      {{yield}}
    end
  end
end
