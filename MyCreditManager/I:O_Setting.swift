//
//  I:O_Setting.swift
//  MyCreditManager
//
//  Created by 김태윤 on 2022/11/16.
//

import Foundation
public enum ProgramType{
    case cmd
}
public enum Action:String,CaseIterable{
    case append = "추가"
    case delete = "삭제"
}
public enum Target:String,CaseIterable{
    case student = "학생"
    case subject = "과목"
}
public enum Message{
    public enum Error{
        case event(action:Action,target:Target)
        case input
        case rate
    }
    public enum Guide{
        case event(action:Action,target:Target)
        case base
        case rate
    }
    case error(type:Error)
    case inputGuide(Guide)
    case quitProcess
    case completed(Guide)
}
func Output(_ type:ProgramType,_ msg:Message,_ args: String...){
    switch type{
    case .cmd:
        switch msg{
        case .inputGuide(let guide):
            switch guide{
            case .base:
                print("원하는 기능을 입력해주세요\n1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료")
            case .rate:
                print("평점을 알고 싶은 학생의 이름을 입력해주세요")
            case .event(let action,let target):
                switch (action,target){
                case (_,.student):
                    print("\(action.rawValue)할 \(target.rawValue)의 이름을 입력해주세요")
                case (.append,.subject):
                    print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+ ,A ,F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift A+\n만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.")
                case (.delete,.subject):
                    print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift")
                }
            }
        case .quitProcess:
            print("프로그램을 종료합니다.")
        case .error(let myError):
            switch myError{
                case .input: print("입력이 잘못되었습니다. 다시 확인해주세요.")
                case .rate: print("\(args[0]) 학생을 찾지 못했습니다.")
                case .event(let action, let target):
                switch (action,target){
                    case (.append, .student): print("\(args[0]) 학생을 추가했습니다.")
                    case(.delete,.student): print("\(args[0]) 학생을 찾지 못했습니다.")
                    case(.append,.subject): print("\(args[0]) 학생의 \(args[1])과목이 \(args[2])로 추가(변경)되었습니다.")
                    case (.delete,.subject): print("\(args[0]) 학생의 \(args[1])과목의 성적이 삭제되었습니다.")
                }
            }
        case .completed(let guide):
            switch (guide){
            case .rate:
                print("평점: \(args[0])")
            case .event(let action,let target):
                switch (action,target){
                    case (.append,.student): print("\(args[0]) 학생을 추가했습니다.")
                    case (.delete,.student): print("\(args[0]) 학생을 삭제하였습니다.")
                    case (.append,.subject): print("\(args[0]) 학생의 \(args[1]) 과목이 \(args[2])로 추가(변경)되었습니다.")
                    case (.delete,.subject): print("\(args[0]) 학생의 \(args[1]) 과목의 성적이 삭제되었습니다.")
                }
            default: break
            }
        }
    }
}
