module CrystalIrc
  VERSION = YAML.parse({{ system("cat", "shard.yml").stringify }})["version"]
end
