# Ruby class interface to CLI grep
class Grep

  DEFAULT_OPTIONS = [
    '--with-filename',
    '--line-number',
  ]

  def initialize(options={})
    grep = options.delete(:grep) || "/bin/grep"
    cli_options = options.delete(:cli_options) || []

    @grep = "%s %s" % [
      grep,
      (DEFAULT_OPTIONS + cli_options).join(" "),
    ]
  end

  def grep(files, regexp)
    if files.respond_to?(:values)
      files = files.invert()
      file_paths = files.keys()
    else
      file_paths = files
      files = files.inject({}) do |c, n|
        c[n] = n; c
      end
    end

    file_string = file_paths.map { |file|
      "\"%s\"" % file
    }.join(" ")
    cmd = "%s --regexp=\"%s\" %s" % [@grep, regexp.gsub(/"/, '\"'), file_string]

    results = []

    current_file_index  = 0
    previous_file_name   = file_paths[current_file_index]
    current_file_name   = file_paths[current_file_index]
    current_file_length = current_file_name.length()
    section     = 0
    matches     = []

    %x[#{cmd}].each_line do |line|
      line = line.chomp()

      if line == '--'
        section += 1
      else

        if line =~ /^(.+?)[-:](\d+)([-:])\[(.+)\] (.*)$/
          previous_file_name = current_file_name
          match = {
            'context' => $3 == '-',
            'number'  => $2,
            'time'    => $4,
          }
          current_file_name = $1
          line = $5
        else
          next
        end

        if previous_file_name != current_file_name
          if matches.length() > 0
            results.push({
              'name' => files[previous_file_name].to_s,
              'matches' => matches,
            })
            matches.clear()
          end
          section = 0
        end

        matches[section] ||= []

        if line =~ /\<(.*)\> (.*)/
          matches[section].push(match.merge({
            'nick'    => $1,
            'text'    => $2,
          }))
        else
          matches[section].push(match.merge({
            'text'    => line,
          }))
        end
      end
    end

    if matches.size() > 0
      results.push({
        'name' => files[previous_file_name].to_s,
        'matches' => matches,
      })
    end

    return results
  end
end
