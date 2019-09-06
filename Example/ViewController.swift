//
//  ViewController.swift
//  Example
//
//  Created by Mark Evans on Sep 5, 2019.
//  Copyright © 2019 3Advance LLC. All rights reserved.
//

import UIKit
import AWS3A

// MARK: - ViewController

/// The ViewController
class ViewController: UIViewController {

    // MARK: Properties
    
    /// The Label
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "🚀\nAWS3A\nExample"
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()

    var testAccessToken = "eyJraWQiOiJIZUN1MUREY0creG10OGMrYVZINnZlQnN2SDlpXC91Wm9FWVk1dWd2cVd4ND0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIwYWNiYjA0Yi0wNmQ0LTQ5MzEtYjAyYi1lOGZmYzY0ZWZmYzkiLCJldmVudF9pZCI6ImNmZjZiMGZmLTFhMWYtNDEzOC04MTI2LTk5YjE0MTBkODZkMSIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE1Njc3MzE3NjUsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC51cy1lYXN0LTEuYW1hem9uYXdzLmNvbVwvdXMtZWFzdC0xX2FtM3hSRTNqSyIsImV4cCI6MTU2NzczNTM2NSwiaWF0IjoxNTY3NzMxNzY1LCJqdGkiOiJiMThlNjRiNC0yODc2LTQ4OWEtOTMwNS0xYzYxMzhmNzk0MjQiLCJjbGllbnRfaWQiOiIzc3AwN2Z0bnVrdmpjbTA1b3ZybjM4N2V2bSIsInVzZXJuYW1lIjoibWV2YW5zanJAZ21haWwuY29tIn0.nIEnkAvoMYSEnxX3l5x5x5TU_oVWLbLtQvLpjrtdIY7PwyTEMSld1pIM-38GujHeKaosBoEdIUU7oEzGv3Hao2Bpqys3mrORN0rjxwOhGeWa3llC2KJJtk5UVQAaNJnESxeJl55LulAHvAN3kRMOm__9b27Qv7R5dTdWGMrbGwW9JS5HRSYmj9lh6TxG6lFs-RHdVsWpIQJDkKSMOCfcMPBCFIoHkTupk8Pxi7rQmuHmX4gtMTHsXGJ2xT78hWr0A2W6-t9lK8I1Czye2hwZsUje8h2pnuhRhJ-454tFbR34PE6EAmA8CWUSpCS90LjMmL1FqERhXKamv32xT519XA"

    var testRefreshToken = "eyJjdHkiOiJKV1QiLCJlbmMiOiJBMjU2R0NNIiwiYWxnIjoiUlNBLU9BRVAifQ.pWhqfD2KUVixMLf-flPw9MW67dO94d6bSpdjm3g93eNPCZYOBcP9T6iNbIOUSqwifRxgNNYCKOHf07A1lSans4UGOjn4FYLnJpoihW-9-aSm9VaqlO4w1J1IOPaqAsNWoJLkNryb6ABPw7fkSHUCb_UiEweVJkC5N3f7ApdG-c2AjOwzgXa-goes-6lEFFvYnC7pF8P2uDb4BWgaGEnI6k4MJ_9WwwtQkcq1gIyRGyaOKN21N5eaQFJOHf8sRjYsK23HhmPGKZrlc0n7fVgcJrXhrV86g8OZU0EYyYMQ7Af1ezKvB8zZdPwzoht5C5q0JTkcdjsXJfSqu3SuwDRwVg.vRx6T75ZmRBL1ys4.aAQ-K2S4lefsyppxmP6F0UP_zsmBGv6aKBnVvzjh6k5prrZ0SaMtWG9i1dgImnnsh1L0FIC856zWuyZOfbrSk5p3DosOzaj7Mm5SGcx0gIs-LG761XhuHN9-tTZU2EpEnZh3-10S0cmeWIpp7mXnI64fC6ZHKoMyvjAR4d-Aac4a1BOvKfxdak_HLDPNEqNohkfEETBjl3v5zOiZeJ0Txoe-EFWJPL-0YoIruZ6lDIpim3aTfpJ0RDn8pkNOQ3Pghm3kBS6SH5lWjAgbKCw1X8O1FvRasRowkN8BqtZYcHRiyhSbmdReEOOxMH0ULS3ctuAP3Jt38M2slDgKeBvx7HrkFeEvCFVYp5no2XjZgDyJwBh4GRnQbqihe44zhstNs7Gvn1JX08-NyA0bfaf0tMs3xSAL3_9FGbQN2iZcaXMeEICeGMbgN87oMTTn-zrwGUaUBn4tpGt9hDannzgek6VlJJyO0JYBRtIt4y4gNPFN1cP9wFGWZKI1zdtEmebN3oweOS5EuPMesiMbDcmBvgwcXvQfHEavz0aVOz0CBKl0Z8GDBR8WYHjlAYtSDB1B1fDkSzBoIyfypavT_GVFGNf21gK7nVivALKNB6uPacHmGzuT0yLqgTzWsEytnlyBKkLTMILz3d7YsH-CydEvwAwUttHoIcBXsYJ6nh4xVOZN0Yt1HnOxhZPi2i1LSynsE74VA7PfZPwbsnTzC15sVxv0jk5mNjPFsb2VzSC71jQPP8fWKlQw-ie97JOzztvIEudSd1C-1HLhZsl-y_XWmeT6WUbp2gll0ahLh84k4q4W4qqpMejp9Qb4LTdYfO6UsiZLq9y_MZmAoGd91cJqnu504Bkt5IcgRDAV-raJdZYqoeGzJSM5QttuHM9j_zqveFIoC6Uoye3bk43eB7SXPZQxYT95R0jHfkjSjVNtbJ5PF2VQztXZE8BE_ha6pPvnzJZwfS0flYBvo5vCr1NqSFs5RyVRcYbasC2wWv_2CF_-2VjGRgXXmbj4eUISyzwOHEzTATzGTrAdOe6pS_3nBm7tOG5Yo2AZUBADY4XukUhDcEbgoKi-pMiisU8FL7prwX4GP2QYdxH9E41lVeh7ovlUgL_rAgZyCbsdhiJxJqWxVnpC_b5RDdOjDXzKOWmTMohlNXsIFsmliBFCfjVmmzroa2id2v3v6f9kD-d5n4wIVd3_M_5Q0edtpRqslOxhNqhX6HXucCSmmX63QqqYugVhbpJ1BG9AX5oBFPYofgQ5SczGpNfCXxyFbRLfKoFohyuYjyD3qFsJQfUiKx2t1P-XXg.mPRmSUK8nyFrE7_lJYgQPQ"

    var testSession = "_YR_cccAGijmG5I7AcsiJoNG_lOrFU8xITYu9ApYvDx4N_QB4sUgpQ7eoBVKKIuNNbTIXYVDlgijJ1HTULUB-WKE8Nsdj971t6F_cHhXwtTMpPPLP4dlAjdHFhuftHRxgaOWOPsp9lkXuNjeZLFPDolgkDYa27Mm5j2wGmhMJvusRODuv6Pm9rAnKpzlQoTnZ7jrbR2wJ6yQqc5BwTs0XFDyu6FsAXzEUW76AJ6BwZvvDiec8rNq5LmjLsIxqJOOjdBk_eC58jGO5jwfbwx5NAIzKBfiu4chefUy8MNNmIMESzp0jqtnB_JmvEqlM45Yh-Dpm8oXAQ6k2vK2X-cHQCRqq5aCrPivZEi64W5M2dij9GcqvbfYz1jvXAh707KF4xr5hM_XrKSKono84ajYWvvJZjTnxktHn2BxfiUfk6o3Rj3LefpC8VMOSjgrKEfVF3FeBi39E3LODUaFMF6Lf6DCVcEgL5C30m79qiOeBzA4GXcYT2ukqVhfbAt_g_xsAvytZoF-t5yWoYh6t3U4OVZfcLrXswLAeDIlLQ62H_mbrGAGmG1neJm5NLQGBQxojPI3PlvfnteSatyQvRP23F2iL7aN0-nu1j7KxYPbwZMO4_Junw3aoM0SgxGckjhfOAPNyYJNPXshRZf37zTofDig_gaFWP73oPJLl6IG0KGK1QaP9GWb6B8yfHjr2g5Yk4OGr90yZ2XsZebLCgH8Edy4aZHGrh2zw6os6YKXziuwfoYYyh9JQIvez3x4gaB-FL2ourX3Gjii88mjQ5WAXEBys_ERf-Nh6uh9UAkULabu01eozIes0V5cj-PqOewo-ls4iMv6zAZsxp8u76p-E2m6c7T645ZpDabXQk7Z1A011fTF0mDH5ZvGMAHNYRrn6rDrX-kYIiZErO0VbsNRZq3hhOMXQTesNslfQtubWfC7kx10YZwh799H28DfzzEephJ48rHmbok"
    
    // MARK: View-Lifecycle
    
    /// View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

//        AWSService.shared.confirmUser(email: "mevansjr@gmail.com", newPassword: "!Therock578", session: self.testSession) { (success, error) in }
        AWSService.shared.loginUser(email: "mevansjr@gmail.com", password: "!Therock578") { (success, error) in }
//        AWSService.shared.confirmRegisterUser(email: "mevansjr@gmail.com", code: "479561") { (success, error) in }
//        AWSService.shared.registerUser(email: "mevansjr@gmail.com", password: "!Therock578") { (success, error) in }
//        AWSService.shared.refreshToken(refreshToken: self.testRefreshToken) { (success, error) in }
//        AWSService.shared.validateUser(accessToken: self.testAccessToken) { (success, error) in }
//        AWSService.shared.logout(accessToken: self.testAccessToken) { (success, error) in }
//        AWSService.shared.resetPassword(username: "mevansjr@gmail.com") { (success, error) in }
//        AWSService.shared.resetConfirmPassword(username: "mevansjr@gmail.com", password: "!Therock578", code: "504017") { (success, error) in }
    }
    
    /// LoadView
    override func loadView() {
        self.view = self.label
    }
}
