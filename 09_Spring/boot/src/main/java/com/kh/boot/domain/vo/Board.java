package com.kh.boot.domain.vo;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Board {
    private int boardNo;
    private String boardTitle;
    private String boardWriter;
    private String boardContent;
    private String originName;
    private String changeName;
    private int count;
    private String createDate;
    private String status;
}
