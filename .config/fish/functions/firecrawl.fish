# Redirect firecrawl's hardcoded .firecrawl/ output dir to /tmp.
function firecrawl --description "Wrap firecrawl so .firecrawl/ output lands in /tmp, not cwd"
    set --local tmpdir (mktemp -d /tmp/firecrawl-XXXXXX)
    set --local cwd (pwd)
    set --local code 0
    if contains -- $argv[1] scrape crawl search
        cd $tmpdir
        command firecrawl $argv
        set code $status
        cd $cwd
        return $code
    else
        command firecrawl $argv
    end
end
