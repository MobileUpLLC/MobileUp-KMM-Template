//
//  SplashController.swift
//  iosApp
//
//  Created by Чаусов Николай on 08.06.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

final class SplashController: HostingController<SplashView> {
    init(onAnimationFinished: @escaping Closure.Void) {
        super.init(rootView: SplashView(onAnimationFinished: onAnimationFinished))
    }
}
