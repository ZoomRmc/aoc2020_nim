--gc:orc
if defined(release):
    --opt:speed
    --passC:"-flto"
    --passL:"-flto"
