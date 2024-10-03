//
//  ContentView.swift
//  MyBookApp
//
//  Created by Гриша Шкробов on 15.08.2024.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    
    
    // Плеер для проигрывания
    @State private var audioPlayer: AudioPlayer?
    // Отслеживание проигрывания
    @State private var play = false
    // Кнопка наушники/текст
    @State private var isPresent = false
    // Скорость воспроизведения
    @State private var currentRate = 1.0
    // Строковое представление скорости воспроизведения
    @State private var currentRateString = "1"
    // Текущее кол-во секунд
    @State private var currentSecond = 0
    // Значение пикселей для установки слайдера и синей полоски
    @State private var value: CGFloat = 0
    // Общее время воспроизведения
    @State private var allSecond = 0
    // Ширина линии плеера
    private let lineSize = UIScreen.screenWidth/2+50
    // Блокировка перемещения слайдера по таймеру во время его свайпа
    @State private var nowTappSlider = false
    // Отображение названя аудио
    @State private var nameAudio = "Design is not how a thing looks, but how it\n works"
    
    // Таймер для актуализации времени воспроизведения на экране
    @State private var timer: Timer?
    
    var body: some View {
        VStack{
            Image("BookImage")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.screenHeight/2.5, height: UIScreen.screenHeight/2.5)
                .padding(20)
            Text("KEY POINT \(Sounds.index+1) OF \(Sounds.list.count)")
                .font(.system(size: 15, weight: .semibold))
                .kerning(1.3)
                .foregroundStyle(.gray)
                .padding(5)
            Text(nameAudio)
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .padding(5)
            
            CustomPlayLine(value: $value, currentSeconds: $currentSecond, nowTapp: $nowTappSlider, lineSize: lineSize, allSeconds: allSecond)
            
            Button(action: {
                updateRate()
            }, label: {
                Text("Speed x\(currentRateString)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.black)
                    .padding(9)
                    .background(.gray.opacity(0.3))
                    .cornerRadius(6.0)
                
            })
            
            Spacer()
            
            HStack{
                Button(action: {
                    lastSound()
                }, label: {
                    Image(systemName: "backward.end.fill")
                        .scaleEffect(1.5)
                        .foregroundStyle(.black)
                })
                Spacer()
                Button(action: {
                    let resultTime = (audioPlayer?.getCurrentPlaybackTime() ?? 0) - TimeInterval(5)
                    audioPlayer?.playFromTimeInterval(from: resultTime)
                    play = true
                }, label: {
                    Image(systemName: "gobackward.5")
                        .scaleEffect(2)
                        .foregroundStyle(.black)
                })
                Spacer()
                Button(action: {
                    if(play){
                        stopSound()
                    }else{
                        startPlaySound()
                    }
                    
                }, label: {
                    Image(systemName: play ? "pause.fill" : "play.fill")
                        .animation(.default.speed(4))
                        .scaleEffect(2.5)
                        .foregroundStyle(.black)
                })
                Spacer()
                Button(action: {
                    let resultTime = (audioPlayer?.getCurrentPlaybackTime() ?? 0) + TimeInterval(10)
                    audioPlayer?.playFromTimeInterval(from: resultTime)
                    play = true
                }, label: {
                    Image(systemName: "goforward.10")
                        .scaleEffect(2)
                        .foregroundStyle(.black)
                })
                Spacer()
                Button(action: {
                    nextSound()
                }, label: {
                    Image(systemName: "forward.end.fill")
                        .scaleEffect(1.5)
                        .foregroundStyle(.black)
                })
            }
            .padding(.horizontal, 70)
            
            Spacer()
            
            CustomSliderButton(isTapped: $isPresent)
            
        }
        .onChange(of: nowTappSlider) { oldValue, newValue in
            if(newValue == false){
                audioPlayer?.playFromTimeInterval(from: TimeInterval(currentSecond))
            }
        }
    }
    
    // Обновить скорость воспроизведения
    func updateRate(){
        
        if(audioPlayer == nil){
            return
        }
        
        if(currentRate == 1.0){
            currentRate = 1.5
            currentRateString = "1.5"
            audioPlayer?.setPlaybackRate(rate: Float(currentRate))
        }else if(currentRate == 1.5){
            currentRate = 2.0
            currentRateString = "2.0"
            audioPlayer?.setPlaybackRate(rate: Float(currentRate))
        }else if(currentRate == 2.0){
            currentRate = 1.0
            currentRateString = "1.0"
            audioPlayer?.setPlaybackRate(rate: Float(currentRate))
        }
    }
    
    // Вперед
    func nextSound(){
        guard let soundName = Sounds.getNextSoundName(), let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Sound file not found")
            return
        }

        loadSound(url: url, soundName: soundName)
    }
    
    // Назад
    func lastSound(){
        guard let soundName = Sounds.getLastSoundName(), let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Sound file not found")
            return
        }

        loadSound(url: url, soundName: soundName)
    }
    
    // Пауза
    func stopSound(){
        play.toggle()
        audioPlayer?.pause()
    }
    
    // Блок работы таймера для актуализации времени воспроизведения и перемещения слайдера
    func timerBlock(){
        if(nowTappSlider){
            return
        }
        currentSecond = Int(audioPlayer?.getCurrentPlaybackTime() ?? 0)
        let procent = Float(Float(currentSecond)/Float(allSecond))
        withAnimation{
            value = lineSize * CGFloat(procent)
        }
    }
    
    // Продолжить воспроизведение
    func continuePlaySound(){
        play.toggle()
        audioPlayer?.continuePlay()
    }
    
    // Нажатие кнопки play
    func startPlaySound() {
        
        if(Sounds.index != -1){
            continuePlaySound()
            return
        }
    
        guard let soundName = Sounds.getNextSoundName(), let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Sound file not found")
            return
        }

        loadSound(url: url, soundName: soundName)
    }
    
    // Загрузка аудио в плеер
    func loadSound(url: URL, soundName: String){
        
        audioPlayer?.stop()
        audioPlayer = nil
        
        do {
            audioPlayer = AudioPlayer(audioFileUrl: url)
            play = true
            audioPlayer?.startPlay()
            allSecond = Int(audioPlayer?.getDuration() ?? 0)
            nameAudio = soundName
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
                self.timerBlock()
            })
            audioPlayer?.setPlaybackRate(rate: Float(currentRate))
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
}

#Preview {
    ContentView()
}

class Sounds{
    public static let list = [
        "01 Kubok (V Jukovskiy-balladi i povest) - Bibe.ru",
        "02 Adelstan (V Jukovskiy-balladi) - Bibe.ru",
        "03 Varvik (V Jukovskiy-balladi) - Bibe.ru",
        "04 Ballada v kotoroy opisivaetsya kak odna starushka ehala na kone (V Jukovskiy) - Bibe.ru",
        "05 Eolova arfa (V Jukovskiy-balladi) - Bibe.ru",
        "06 Mschenie (V Jukovskiy balladi) - Bibe.ru",
        "07 Garald (V Jukovskiy-balladi) - Bibe.ru",
        "08 Tri pesni (V.Jukovskiy-balladi) - Bibe.ru",
        "09 Ribak (V Jukovskiy-balladi) - Bibe.ru",
        "10 Ritsar Togenburg (V Jukovskiy-balladi) - Bibe.ru",
        "11 Perchatka (V Jukovskiy-balladi) - Bibe.ru",
        "12 Graf Gapsburgskiy (V Jukovskiy-balladi) - Bibe.ru",
        "13 Zamok Smalgolm ili Ivanov vecher (V Jukovskiy-balladi) - Bibe.ru",
        "14 Torjestvo pobediteley (V Jukovskiy-balladi) - Bibe.ru",
        "15 Polikratov persten (V Jukovskiy-balladi) - Bibe.ru",
        "16 Jaloba Tsereri (V Jukovskiy-balladi) - Bibe.ru",
        "17 Sud Bojiy nad episkopom (V Jukovskiy-balladi) - Bibe.ru",
        "18 Alonzo (V Jukovskiy-balladi) - Bibe.ru",
        "19 Pokayanie (V Jukovskiy-balladi) - Bibe.ru",
        "20 Koroleva Uraka i pyat muchenikov (V Jukovskiy-balladi) - Bibe.ru",
        "21 Roland orujenosets (V Jukovskiy-balladi) - Bibe.ru",
        "22 Plavanie Karla Velikogo (V Jukovskiy-balladi) - Bibe.ru",
        "23 Ritsar Rollon (V Jukovskiy-balladi) - Bibe.ru",
        "24 Stariy ritsar (V Jukovskiy-balladi) - Bibe.ru",
        "25 Bratoubiytsa (V Jukovskiy-balladi) - Bibe.ru",
        "26 Ivikovi juravli (V Jukovskiy-balladi) - Bibe.ru",
        "27 Elevzinskiy prazdnik (V Jukovskiy-balladi) - Bibe.ru",
        "28 Lesnoy tsar (V Jukovskiy-balladi i povest) - Bibe.ru",]
    
    public static var index = -1
    
    public static func getNextSoundName() -> String? {
        
        if(index >= list.count){
            return nil
        }
        
        index += 1
        
        return list[index]
    }
    
    public static func getLastSoundName() -> String? {
        
        if(index == 0){
            return nil
        }
        
        index -= 1
        
        return list[index]
    }
}
