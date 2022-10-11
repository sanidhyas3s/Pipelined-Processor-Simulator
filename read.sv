module read(input string source, output string code[$]);
    integer fd;
    string line;
    initial begin
        fd = $fopen(source,"r");
        if(fd) begin
            $fgets(line,fd);
            while(line!="{") begin
               $fgets(line,fd);
            end
            $fgets(line,fd);
            while(line!="}") begin
                code.push_back(line);
                $fgets(line,fd);
            end
        end
    end
endmodule