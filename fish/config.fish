## config.fish

# 檢查檔案是否存在並匯入必要的環境變數
if status is-interactive
    set -l shell_rc
    if test -f "$HOME/.bashrc"
        set shell_rc "$HOME/.bashrc"
    else if test -f "$HOME/.zshrc"
        set shell_rc "$HOME/.zshrc"
    end

    if set -q shell_rc
        # 只匯入 PATH 和必要的環境變數
        for line in (bash -c "source $shell_rc; env | grep -E '^(PATH|HOME|USER|CARGO_HOME|RUSTUP_HOME|NVM_DIR|GOPATH|GOROOT)='")
            set -l key_value (string split -m 1 '=' $line)
            set -gx $key_value[1] $key_value[2]
        end
    end
end

# Rust/Cargo 路徑
set -gx PATH $PATH ~/.cargo/bin

#Ctrl+s切換至root
function fish_user_key_bindings
    bind \cs 'commandline -r "sudo su"; commandline -f execute' # Ctrl+S 進 root
    bind \ce 'commandline -r "exit"; commandline -f execute' # Ctrl+E 退出
end
