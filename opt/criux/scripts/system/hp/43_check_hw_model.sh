# 43_check_hw_model.sh
case "$(uname -m)" in
    "9000*" ) Warn "PA-Risc systems are getting out of support." ;;
    "ia64"  ) Ok "Hardware model is still supported." ;;
esac
