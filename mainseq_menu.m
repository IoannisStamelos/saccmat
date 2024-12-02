function mainseq_menu(position,datai)
    
        [lsac,rsac,gazer,gazel] = deal(datai{1},datai{2},datai{9},datai{10});
        main_sequence4menu(gazer, rsac,"Right",position);
        main_sequence4menu(gazel, lsac,"Left",position);
    
end
