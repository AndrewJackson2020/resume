
if ($args[0] = 'build_resume'){
    pdflatex `
        -aux-directory tmp `
        resume.tex
    Remove-Item -r tmp
} 
