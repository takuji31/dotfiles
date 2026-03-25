function check-modern-tools -d "Check for missing modern CLI tools"
    set -l missing_tools
    # Only check tools not managed by mise
    for tool in btop
        if not command -q $tool
            set -a missing_tools $tool
        end
    end
    if test (count $missing_tools) -gt 0
        set_color yellow
        echo "Missing CLI tools: $missing_tools"
        echo "Run 'install-modern-tools' to install them."
        set_color normal
    end
end
